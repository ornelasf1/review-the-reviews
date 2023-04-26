module Utils
    def get_hostname url
        if url =~ /\Ahttps?:\/\//
            URI.parse(url.strip).hostname
        else
            URI.parse("http://" + url.strip).hostname
        end
    end

    def strip_www hostname
        hostname.remove "www."
    end
end