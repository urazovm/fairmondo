module Exporter
  class CSVExporter
    class_attribute :export_mapping, :file_name, :csv_options

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
        when empty_or_nil_in?(value)
          attrs << value
        when string_or_symbol_in?(value)
          begin
            attrs << item.instance_eval(value.to_s)
          rescue
            attrs << value
          end
        when value.is_a?(Proc)
          attrs << item.instance_exec(&(value))
        end
      end
      attrs
    end

    def empty_or_nil_in? value
      value == nil || value == ''
    end

    def string_or_symbol_in? value
      value.is_a?(String) || value.is_a?(Symbol)
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

      def file_path string
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
        @file_name ||= ''
      end
    end
  end
end
