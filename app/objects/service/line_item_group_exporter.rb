class LineItemGroupExporter < Exporter::CSVExporter
  mapping do
    field id: :id
    field sold_at: ->{ sold_at.strftime('%d.%m.%Y %H:%M') }
    field transaction_id: :purchase_id
    field article_title: ->{ self.articles.last.title }
    field created_at: ->{ created_at }
    field shipping_address: ->{ transport_address.instance_exec {
        addr = ''
        addr << title + ' ' if title
        addr << first_name + ' ' + last_name
        addr << ', ' + company_name if company_name
        addr << ', ' + address_line_1
        addr << ', ' + address_line_2 if address_line_2
        addr << ', ' + zip
        addr << ', ' + city
      }
    }
    field payment_address: ->{ payment_address.instance_exec {
        addr = ''
        addr << title + ' ' if title
        addr << first_name + ' ' + last_name
        addr << ', ' + company_name if company_name
        addr << ', ' + address_line_1
        addr << ', ' + address_line_2 if address_line_2
        addr << ', ' + zip
        addr << ', ' + city
      }
    }
  end

  destination "#{ Rails.root }/public/fairmondo_articles.csv"
end
