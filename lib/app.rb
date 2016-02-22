require 'json'

def setup_files
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)
	$report_file = File.new("report.txt", "w+")
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

def create_report
	#print_sales_report
	print_products
	loop_product_data
	#print_brands
	#loop_brand_data
	File.open("report.txt", "w") do |somefile|
		somefile.puts print_report_date
		somefile.puts print_products
		somefile.puts calculate_products
		somefile.puts print_brands
	end
end

# Print today's date
def print_report_date
	date = Time.now.strftime("%D")
	"Sales report for #{date}"
end

# Print "Products" in ascii art
def print_products
"

                    | |          | |
 _ __  _ __ ___   __| |_   _  ___| |_ ___
| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|
| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\
| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/
| |
|_|
	                                 "
end

#Products Report
def loop_product_data
	$products_hash["items"].each do |toy|
		$toy_title = toy["title"]
		$retail_price = toy["full-price"]
		$number_of_products = toy["purchases"].length
		$total_sales = 0
		toy["purchases"].each do |sales|
			$total_sales += sales["price"]
		end
		calculate_products
	end
end

def calculate_products
	"	#{spacer}
	#{print_toy_title($toy_title)}
	#{print_toy_retail_price($retail_price)}
	#{print_toy_total_sales($total_sales)}
	#{calculate_average_sales($total_sales, $number_of_products)}
	#{calculate_average_discount($total_sales, $retail_price, $number_of_products)}"
end

def spacer

	"**************************"
end

def print_toy_title(toy_title)
	$toy_title
end

def print_toy_retail_price(retail_price)
	 "Retail Price: $#{retail_price}"
end

def print_toy_total_sales(total_sales)
	 "Total sales: $#{total_sales}"
end

def calculate_average_sales(total_sales, number_of_products)
	 "Average sale: $#{total_sales/number_of_products}"
end

def calculate_average_discount(total_sales, retail_price, number_of_products)
	 "Average discount: #{(1 - total_sales/(retail_price.to_f * number_of_products)).round(3)*100}%"
end

# Print "Brands" in ascii art
def print_brands
"

| |                       | |
| |__  _ __ __ _ _ __   __| |___
| '_ \\| '__/ _` | '_ \\ / _` / __|
| |_) | | | (_| | | | | (_| \\__ \\
|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
end

#Arrary containing unqiue brands used to create new arrarys by brand
def dedup_brands
 $products_hash["items"].map {|iso| iso["brand"]}.uniq
end

#Sets filter to create new array by brand
def loop_brand_data
	dedup_brands.each do |brand|
		#Creates new array by brand
		toys_by_brand = $products_hash["items"].select {|item| item["brand"]==brand}
		#Reset variables as we iterate through hash
		$sale_price = 0
		$retail_price = 0
		#Iterates through new arrays by brand
		toys_by_brand.each do |bought|
			$brand_title = bought["brand"]
			$retail_price += bought["full-price"].to_f
			$brand_stock = toys_by_brand.map {bought["title"]}.length
			bought["purchases"].each do |toy|
				$sale_price += toy["price"]
			end
		end
		calculate_brands
	end
end

def calculate_brands
	spacer
	print_brand_title
	print_brand_stock
	calculate_average__brand_price($retail_price, $brand_stock)
	calculate_brand_revenue
end

def print_brand_title
	$brand_title
end

def print_brand_stock
	"Number of #{$brand_title} products: #{$brand_stock}"
end

def calculate_average__brand_price(retail_price, brand_stock)
	$average__brand_price = (retail_price/brand_stock).round(2)
	print_average__brand_price
end

def print_average__brand_price
	"Average price of #{$brand_title} toys $#{$average__brand_price}"
end

def calculate_brand_revenue
	"Total #{$brand_title} revenue: $#{($sale_price).round(2)}"
end

start
