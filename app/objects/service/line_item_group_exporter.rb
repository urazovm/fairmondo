require 'exporter'

class LineItemGroupExporter
  attr_reader :user, :exporter

  def initialize user
    @user = user
  end

  @exporter = Exporter.new do
    mapping do
      field id: 'id'
      field sold_at: :sold_at
      field article_title: 'self.articles.last.title'
      field created_at: ->{ created_at }
      field hallo: nil
      field foobar: ''
      field 'hallo' => 'updated_at'
    end

    file_path "#{ Rails.root }/public/fairmondo_articles.csv"
  end

  def export &block
    @exporter.export(block)
  end
end

# export { @user.seller_line_item_groups.includes(:business_transactions, :articles, :buyer) }

#  @@csv_options = { col_sep: ";",  encoding: 'utf-8'}
#
#  # methods for exporting line_item_group articles with corresponding fields of
#  # line_item_group, business_transaction
#  def self.export(csv, user, params)
#    csv.puts(CSV.generate_line(export_attrs, @@csv_options))
#
#    get_line_item_groups(user, params).find_each do |lig|
#      lig.business_transactions.find_each do |bt|
#        row = Hash.new
#        [lig, bt, bt.article, lig.buyer, lig.payment_address, lig.transport_address].each do |obj|
#          option = kind_of_address(obj, lig)
#          attrs = Hash[obj.attributes.map { |k, v| [export_mappings(obj, option)[k], v] }]
#          if obj.class.name == 'BusinessTransaction'
#            attrs['item_unified_transport'] = obj.is_in_unified_transport? ? 'true' : 'false'
#          end
#          row.merge!(attrs.select { |k, v| export_attrs.include?(k) })
#        end
#        csv.puts(CSV.generate_line(export_attrs.map { |element| row[element] }, @@csv_options))
#      end
#    end
#    csv.flush
#  end
#
# TODO refactor, does not seem to work
#  def self.kind_of_address(obj, lig)
#    option = nil
#    if obj == lig.payment_address
#      option = 'payment'
#    elsif obj == lig.transport_address
#      option = 'transport'
#    end
#    return option
#  end
#
#  def self.get_line_item_groups(user, params)
#    if params[:time_range] && params[:time_range] != 'all'
#      user.seller_line_item_groups.where('sold_at > ? AND sold_at < ?', params[:time_range].to_i.month.ago, Time.now).includes(:buyer, :transport_address, :payment_address, business_transactions: [:article])
#    else
#      user.seller_line_item_groups.includes(:buyer, :transport_address, :payment_address, business_transactions: [:article])
#    end
#  end
#
#  # Maps attributes of a model to attribute name prefixed with model name
#  def self.export_mappings(obj, option)
#    hash = {}
#    obj.class.column_names.each { |column_name| hash[column_name] = "#{mapping_name(option)[obj.class.name]}_#{column_name}"}
#    return hash
#  end
#
#  # used to prefix model attributes in csv with user friendly name instead of model name
#  def self.mapping_name(option)
#    {
#      'Article' => 'article',
#      'BusinessTransaction' => 'item',
#      'LineItemGroup' => 'purchase',
#      'User' => 'buyer',
#    }.tap do |hash|
#      hash['Address'] = 'transport_address' if option == 'transport'
#      hash['Address'] = 'payment_address' if option == 'payment'
#    end
#  end
#
#  # used to determine which columns of line_item_groups and business_transactions and articles should be exported
#  # TODO consider which attributes should be exported and write them to the array
#  def self.export_attrs
#    [
#      'purchase_purchase_id', 'purchase_sold_at',
#      'item_id', 'item_quantity_bought', 'item_selected_payment', 'item_selected_transport', 'item_unified_transport',
#      'article_id', 'article_custom_seller_identifier', 'article_title', 'article_price',
#      'buyer_nickname',
#      'payment_address_title', 'payment_address_first_name', 'payment_address_last_name', 'payment_address_company_name',
#      'payment_address_address_line_1', 'payment_address_address_line_2', 'payment_address_zip', 'payment_address_city',
#      'payment_address_country',
#      'transport_address_title', 'transport_address_first_name', 'transport_address_last_name', 'transport_address_company_name',
#      'transport_address_address_line_1', 'transport_address_address_line_2', 'transport_address_zip', 'transport_address_city',
#      'transport_address_country',
#    ]
#  end
#
# end
