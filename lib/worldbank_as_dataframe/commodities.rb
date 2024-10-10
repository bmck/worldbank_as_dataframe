require 'open-uri'
require 'simple_xlsx_reader'
require 'polars-df'

module WorldbankAsDataframe
  class Commodities
    attr_reader :tag

    def initialize(series, options={})
      @tag = series
    end

    def fetch(start: nil, fin: nil)
      doc = SimpleXlsxReader.parse(URI.open('https://thedocs.worldbank.org/en/doc/5d903e848db1d1b83e0ec8f744e55570-0350012021/related/CMO-Historical-Data-Monthly.xlsx'))
      ary = doc.sheets.detect{|sht| sht.name == 'Monthly Prices'}.rows.to_a[4..-1]
      ary[0][0] = 'Timestamps'
      ary.map!{|a| a.reverse.drop_while(&:nil?).reverse }
      ary[1].length.times {|i| ary[1][i] = [ary[0][i], ary[1][i]].compact.join(' ') }
      ary = ary[1..-1]

      ary[1..-1].each{|a| dt = a[0].split('M'); a[0] = Date.new(dt[0].to_i, dt[1].to_i, 1).to_date }

      df = Polars::DataFrame.new(ary[1..-1].transpose, columns: ary[0])
      df = df.filter(Polars.col('Timestamps') >= start.to_date) unless start.nil?
      df = df.filter(Polars.col('Timestamps') <= fin.to_date) unless fin.nil?

      cols = cols.map{|c| (/#{tag.downcase}/ =~ c.downcase).nil? ? nil : c }.compact
      df = df.select(['Timestamps', cols].flatten) if (cols.length>0)

      df
    end
  end
end