module ProductSearch
    include Utils

    def get_products hostname_to_urls_map, category
        hostname_to_product_map = Hash.new
        pool = Concurrent::ThreadPoolExecutor.new(
          min_threads: 5,
          max_threads: 10,
          max_queue: 0
        )
        hostname_to_urls_map.each do |hostname, urls|
          pool.post do
            # hostname to product map is keyed with hostname without path because reviewers store only hostname
            hostname_without_path = get_hostname hostname
            scraper = ScraperFactory.getscraper hostname
            if scraper.blank?
              hostname_to_product_map[hostname_without_path] = Product.new(initial_source: urls[0])
              next
            end
            product = nil
            initial_source = nil # We want to know the initial source to show in the product reviews page the first attempted url - it's likely a relavent helpful url even though it mightve failed to be scraped
            for url in urls do
              if initial_source.blank?
                initial_source = url
              end
              product = scraper.getproduct(category.to_sym, url)
              if product.available?
                puts "#{hostname} - found product in #{url}"
                break
              end
              puts "#{hostname} - attempted #{url}"
            end
            product.initial_source = initial_source
            hostname_to_product_map[hostname_without_path] = product
          end
        end
        pool.wait_for_termination 10
        hostname_to_product_map
    end

    def populate_reviews_for_hostname_map urls, query, category, final_hostname_to_reviews_map, stack_max, page_level
        puts "========"
        if urls.blank?
          puts "no more urls"
          return
        end
        if stack_max >= 10
          puts "Reached max stack"
          return
        end
        hostname_to_reviews_map = search_reviews category, urls, query, page_level
        if hostname_to_reviews_map.blank?
          puts "No more results"
          return
        end
        puts 'analyze hostname_to_reviews_map'
        puts hostname_to_reviews_map
        puts
        hostname_to_reviews_map.each do |hostname, url_buckets|
          if final_hostname_to_reviews_map.has_key? hostname
            final_hostname_to_reviews_map[hostname] += url_buckets
          else
            final_hostname_to_reviews_map[hostname] = url_buckets
          end
          final_hostname_to_reviews_map[hostname].uniq!
        end
        puts 'analyze final_hostname_to_reviews_map'
        puts final_hostname_to_reviews_map
        puts
        puts "old urls: #{urls}"
        new_urls = urls.reject do |url| 
          final_hostname_to_reviews_map.has_key? url and final_hostname_to_reviews_map[url].size >= 3
        end
        puts "new urls: #{new_urls}"
        puts
        if urls.size == new_urls.size
          page_level += 1
        else
          page_level = 0
        end
        stack_max += 1
        populate_reviews_for_hostname_map new_urls, query, category, final_hostname_to_reviews_map, stack_max, page_level
    end
end