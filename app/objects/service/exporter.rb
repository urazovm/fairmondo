module Exporter
  class CSVExporter
    class_attribute :export_mapping, :destination, :csv_options

    def export &block
      CSV.open(file_name, 'wb', csv_options) do |line|
        line << export_mapping.keys

        yield.find_each do |item|
          line << generate_line_for(item)
        end
      end
      self
    end

    private

    def generate_line_for item
      attrs = []
      export_mapping.each do |_key, value|
        case
        when value.is_a?(Symbol)
          attrs << item.send(value)
        when value.is_a?(Proc)
          attrs << item.instance_exec(&(value))
        else
          attrs << value
        end
      end
      attrs
    end

    class << self
      def build
        self.new
      end

      def mapping &block
        yield
      end

      def field hash
        export_mapping.merge! hash
      end

      def destination string
        file_name << string
      end

      def options hash
        @csv_options = hash
      end

      def csv_options
        @csv_options ||= { col_sep: ';',  encoding: 'utf-8' }
      end

      def export_mapping
        @export_mapping ||= {}
      end

      def file_name
        @destination ||= ''
      end
    end
  end
end
