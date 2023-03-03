module ReviewersHelper
    $categoryTitleMap = {
        :videogames => 'Video Game',
        :technology => 'Technology',
        :tabletop => 'Tabletop Games',
        :software => 'Computer Software',
        :vehicles => 'Cars & Other Vehicles',
        :apps => 'Mobile Apps',
        :restaurants => 'Restaurant',
        :food => 'Food'
    }
    def categoryName(category)
        $categoryTitleMap[category]
    end

    def categoryMap
        $categoryTitleMap
    end

    def category_syms
        $categoryTitleMap.keys
    end

    def category_names
        $categoryTitleMap.values
    end
end
