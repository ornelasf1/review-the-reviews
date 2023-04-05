class ScraperFactory
    mattr_reader :scraper_map
    # keys are values found in the reviewer's hostname
    @@scraper_map = {
        'ign' => IgnScraper,
        'gamespot' => GamespotScraper,
        'metacritic' => MetacriticScraper,
        'techradar' => TechradarScraper,
    }
    def self.getscraper name
        key = @@scraper_map.keys.find {|k| name.downcase.include?(k)}
        if key
            @@scraper_map[key]
        else
            nil
        end
    end
end