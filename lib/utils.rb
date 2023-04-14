module Utils
    def get_hostname url
        if url =~ /\Ahttps?:\/\//
            URI.parse(url.strip).hostname
        else
            URI.parse("http://" + url.strip).hostname
        end
    end
end