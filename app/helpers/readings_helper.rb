module ReadingsHelper
    def station_is?(name, stations)
        stations.length.eql?(1) and stations.first.name.eql?(name)
    end
end
