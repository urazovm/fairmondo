class Exporter
  def initialize &block
    @export_mapping = {}
    @file_name = ''
    @csv_options ||= { col_sep: ';',  encoding: 'utf-8' }

    instance_eval(&block) if block_given?
  end

  def build &block
    initialize(&block)
  end

  def export &block
    CSV.open(@file_name, 'wb', @csv_options) do |line|
      line << @export_mapping.keys

      yield.find_each do |item|
        line << generate_line_for(item)
      end
    end
  end

  private

  def generate_line_for item
    attrs = []
    @export_mapping.each do |_key, value|
      case
      when empty_or_nil_in?(value)
        attrs << value
      when string_or_symbol_in?(value)
        attrs << item.instance_eval(value.to_s)
      when value.is_a?(Proc)
        attrs << item.instance_exec(&(value)) if proc_in?(value)
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

  def mapping &block
    yield
  end

  def field hash
    @export_mapping.merge! hash
  end

  def file_path string
    @file_name = string
  end

  def options hash
    @csv_options = hash
  end
end
