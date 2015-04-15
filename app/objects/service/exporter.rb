module CSVExporter
  attr_accessor :export_mapping, :export_header

  def initialize &block
    instance_eval &block if block
  end

  def self.included base
    base.extend ClassMethods
  end

  def export &block
    CSV.open(file_name, 'wb', csv_options) do |line|
      binding.pry
      line << export_header

      yield.find_each do |item|
        line << generate_line_for(item)
      end
    end
  end

  private

  def csv_options
    { col_sep: ';',  encoding: 'utf-8' }
  end

  def generate_line_for item
    attrs = []
    @export_header.each do |attr|
      begin
        attrs << "'#{ item.instance_eval(export_mapping[attr]) }'"
      rescue
        attrs << "'#{ export_mapping[attr] }'"
      end
    end
    attrs
  end

  module ClassMethods
    def export_mapping
      @export_mapping ||= {}
    end

    def export_header
      @export_header ||= []
    end

    def mapping &block
      yield
    end

    def field hash = {}
      export_mapping.merge! hash
    end

    def header
      yield
    end

    def name value
      export_header << value
    end
  end
end
