module( "ncs", package.seeall )

local base_url = "https://ncs.io/"

do

    local pattern = "class=\"player.play\".-data.url=\"(.-)\".-data.artist=.->(.-)</a>.-data.track=\"(.-)\".-data.cover=\"(.-)\".-<span.-class=\"genre\".-title=\"(.-)\">"
    function FindTracks( str, callback )
        if isstring( str ) and isfunction( callback ) then
            http.Fetch( base_url .. "music-search?q=" .. str:Replace( " ", "+" ) .. "&genre=&mood=", function( body, size, headers, code )
                if (code == 200) then
                    local tracks = {}
                    for url, artist, track, cover, genre in body:gmatch( pattern ) do
                        if (url == "") then continue end
                        table.insert( tracks, {
                            ["Title"] = track,
                            ["Artist"] = artist,
                            ["Genre"] = genre,
                            ["URL"] = url,
                            ["Cover"] = cover
                        } )
                    end

                    callback( tracks )
                end
            end,
            function( err )
                callback( {} )
            end)
        end
    end

end