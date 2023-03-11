module ReviewersHelper
    $categoryTitleMap = {
        :videogames => 'Video Game',
        :movies => 'Movies',
        :technology => 'Technology',
        :tabletop => 'Tabletop Games',
        :software => 'Computer Software',
        :vehicles => 'Cars & Other Vehicles',
        :apps => 'Mobile Apps',
        :restaurants => 'Restaurant',
        :food => 'Food'
    }
    $platformTitleMap = {
        :streamer => 'Streamer',
        :website => 'Website'
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

    def platformMap
        $platformTitleMap
    end

    def platform_syms
        $platformTitleMap.keys
    end

    def people_have_reviewed_format_str count
        if count == 1
            "#{count} person has reviewed"
        else
            "#{count} people have reviewed"
        end
    end

    def link_to_add_category(name, form, association)
        new_object = form.object.send(association).klass.new
        id = new_object.object_id
        categories = form.fields_for(association, new_object, child_index: id) do |builder|
          render("category", categories_form: builder, showDeleteBtn: true)
        end
        link_to(name, '#', :onclick => 'addCategoryFieldset(event)', class: "add_categories", data: {id: id, categories: categories.gsub("\n", "")})
    end
end
