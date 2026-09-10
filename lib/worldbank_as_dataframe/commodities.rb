require 'open-uri'
require 'roo'
require 'polars-df'
require 'tempfile'
require 'date'

module WorldbankAsDataframe
  class Commodities
    CMO_URL = 'https://thedocs.worldbank.org/en/doc/5d903e848db1d1b83e0ec8f744e55570-0350012021/related/CMO-Historical-Data-Monthly.xlsx'
    MONTHLY_PRICES_SHEET = 'Monthly Prices'
    MISSING_MARKERS = ["…", "..."].freeze

    attr_reader :tag

    def initialize(series = nil, options={})
      @tag = series
    end

    def fetch(start: nil, fin: nil, path: nil)
      if path
        _frame_from_path(path, start: start, fin: fin)
      else
        Tempfile.open(['cmo', '.xlsx'], binmode: true) do |f|
          f.write(URI.open(CMO_URL, 'User-Agent' => 'worldbank_as_dataframe').read)
          f.flush
          _frame_from_path(f.path, start: start, fin: fin)
        end
      end
    end

    def _frame_from_path(path, start: nil, fin: nil)
      xlsx = Roo::Excelx.new(path)
      rows = _monthly_price_rows(xlsx)
      _build_frame(rows, start: start, fin: fin)
    end

    def _monthly_price_rows(xlsx)
      name = xlsx.sheets.find { |sheet_name| _normalize_key(sheet_name) == _normalize_key(MONTHLY_PRICES_SHEET) }
      raise 'CMO workbook contained no Monthly Prices sheet' if name.nil?

      sheet = xlsx.sheet(name)
      last_row = sheet.last_row
      raise 'CMO Monthly Prices sheet is empty' if last_row.nil?

      (1..last_row).map { |idx| sheet.row(idx) }
    end

    def _build_frame(rows, start: nil, fin: nil)
      ary = rows[4..].map { |row| row.dup }
      raise 'CMO Monthly Prices sheet is missing header rows' if ary.nil? || ary.length < 3

      ary[0][0] = 'Timestamps'
      ary.map! { |a| a.reverse.drop_while(&:nil?).reverse }
      ary[1].length.times { |i| ary[1][i] = [ary[0][i], ary[1][i]].compact.join(' ') }
      ary = ary[1..]

      cols = ary[0]
      dat = ary[1..].map { |row| _coerce_row(row) }
      dat.reject! { |row| row.compact.empty? }

      frame_hsh = {}
      cols.each_with_index { |col, i| frame_hsh[col] = dat.map { |row| row[i] } }
      df = Polars::DataFrame.new(frame_hsh)

      start_date = _to_date(start)
      fin_date = _to_date(fin)
      df = df.filter(Polars.col('Timestamps') >= start_date) unless start_date.nil?
      df = df.filter(Polars.col('Timestamps') <= fin_date) unless fin_date.nil?

      unless @tag.nil?
        matched = cols.select { |c| c.to_s.downcase.include?(@tag.to_s.downcase) }
        df = df.select(['Timestamps', *matched]) if matched.length > 0
      end

      df
    end

    def _normalize_label(text)
      return '' if text.nil?

      text.to_s
          .gsub(/<[^>]+>/, '')
          .gsub(/[[:space:]]+/, ' ')
          .delete('*')
          .strip
    end

    def _normalize_key(text)
      _normalize_label(text).downcase
    end

    def _coerce_row(row)
      row = row.dup
      if row[0].to_s =~ /\A(\d{4})M(\d{2})\z/
        row[0] = Date.new($1.to_i, $2.to_i, 1)
      end
      row.map { |cell| MISSING_MARKERS.include?(cell) ? nil : cell }
    end

    def _to_date(value)
      return nil if value.nil?
      return value if value.is_a?(Date)
      return value.to_date if value.respond_to?(:to_date)

      Date.parse(value.to_s)
    end
  end
end
