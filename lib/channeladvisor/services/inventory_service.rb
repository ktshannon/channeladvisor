module ChannelAdvisor
  module Services
    class InventoryService < BaseService
      document "https://api.channeladvisor.com/ChannelAdvisorAPI/v6/InventoryService.asmx?WSDL"

      class << self
        def ping
          client.request :ping do
            soap.header = soap_header
          end
        end # ping

        def update_inventory_item_quantity_and_price(item_info)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:itemQuantityAndPrice" => {
              "ins0:Sku" => item_info[:sku]
            }
          }

          item_quantity_and_price = soap_body["ins0:itemQuantityAndPrice"]

          if quantity_info = item_info[:quantity_info]
            item_quantity_and_price["ins0:QuantityInfo"] = {
              "ins0:UpdateType" => quantity_info[:update_type],
              "ins0:Total"      => quantity_info[:total]
            }
          end

          if price_info = item_info[:price_info]
            item_quantity_and_price["ins0:PriceInfo"] = {
              "ins0:Cost"                   => price_info[:cost],
              "ins0:RetailPrice"            => price_info[:retail_price],
              "ins0:StartingPrice"          => price_info[:starting_price],
              "ins0:ReservePrice"           => price_info[:reserve_price],
              "ins0:TakeItPrice"            => price_info[:take_it_price],
              "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
              "ins0:StorePrice"             => price_info[:store_price]
            }
          end

          client.request :update_inventory_item_quantity_and_price do
            soap.header = soap_header
            soap.body = soap_body
          end
        end # update_inventory_item_quantity_and_price

        def does_sku_exist_list(skus)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:skuList" => []
          }

          line_items = soap_body["ins0:skuList"]
          skus.each do |sku|
              line_items << {"ins0:string" => sku}
          end

          client.request :does_sku_exist_list do
            soap.header = soap_header
            soap.body = soap_body
          end
        end # does_skus_exist_list

        def update_inventory_item_quantity_and_price_list(quantity_and_price_list)
          soap_body = {
            "ins0:accountID" => creds(:account_id),
            "ins0:itemQuantityAndPriceList" => {
              "ins0:InventoryItemQuantityAndPrice" => []
            }
          }

          quantity_and_price_list.each do |item|
            item_quantity_and_price = {"ins0:Sku" => item[:sku]}

            if quantity_info = item[:quantity_info]
              item_quantity_and_price["ins0:QuantityInfo"] = {
                "ins0:UpdateType" => item[:quantity_info][:update_type],
                "ins0:Total"      => item[:quantity_info][:total]
              }
            end

            if price_info = item[:price_info]
              item_quantity_and_price["ins0:PriceInfo"] = {
                "ins0:Cost"                   => price_info[:cost],
                "ins0:RetailPrice"            => price_info[:retail_price],
                "ins0:StartingPrice"          => price_info[:starting_price],
                "ins0:ReservePrice"           => price_info[:reserve_price],
                "ins0:TakeItPrice"            => price_info[:take_it_price],
                "ins0:SecondChanceOfferPrice" => price_info[:second_chance_offer_price],
                "ins0:StorePrice"             => price_info[:store_price]
              }
            end

            soap_body["ins0:itemQuantityAndPriceList"]["ins0:InventoryItemQuantityAndPrice"] << item_quantity_and_price
          end


          client.request :update_inventory_item_quantity_and_price_list do
            soap.header = soap_header
            soap.body = soap_body
          end
        end # update_inventory_item_quantity_and_price_list
      end # self
    end # InventoryService
  end # Services
end # ChannelAdvisor