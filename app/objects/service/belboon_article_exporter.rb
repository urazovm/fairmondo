class BelboonArticleExporter < Exporter::CSVExporter
  mapping do
    field 'Merchant_ProductNumber' => 'slug'
    field 'EAN_Code' => 'gtin'
    field 'Product_Title' => 'title'
    field 'Manufacturer' => nil
    field 'Brand' => nil
    field 'Price' => "Money.new(self.price_cents).to_s.gsub(',', '.')"
    field 'Price_old' => nil
    field 'Currency' => "'EUR'"
    field 'Valid_From' => nil
    field 'Valid_To' => nil
    field 'DeepLink_URL' => "'https://www.fairmondo.de/articles/' + slug"
    field 'Into_Basket_URL' => nil
    field 'Image_Small_URL' => "'https://www.fairmondo.de/' + title_image_url(:thumb)"
    field 'Image_Small_HEIGHT' => "'200'"
    field 'Image_Small_WIDTH' => "'280'"
    field 'Image_Large_URL' => "'https://www.fairmondo.de/' + title_image_url(:medium)"
    field 'Image_Large_HEIGHT' => nil
    field 'Image_Large_WIDTH' => nil
    field 'Keywords' => nil
    field 'Merchant_Product_Category' => nil
    field 'Product_Description_Short' => nil
    field 'Product_Description_Long' => 'Sanitize.clean(content)'
    field 'Last_Update' => 'updated_at'
    field 'Shipping' => nil
    field 'Availability' => "'sofort lieferbar'"
    field 'Optional_1' => 'id'
    field 'Optional_2' => nil
    field 'Optional_3' => nil
    field 'Optional_4' => nil
    field 'Optional_5' => nil
  end

  file_path = Rails.env == 'development' ?
    "#{ Rails.root }/public/fairmondo_articles.csv" :
    '/var/www/fairnopoly/shared/public/system/fairmondo_articles.csv'
end
