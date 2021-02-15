function ascii(file, landscape; x=0.0, y=0.0, s=1.0, nodata_value=-999)
    open(file, "w") do io
        # TODO change this line to read actual values
        #templ = readlines(joinpath("results", "60", "BPy_output", "cum_currmap.asc"))[1:6]
        header = """
        ncols            $(size(landscape,1))
        nrows            $(size(landscape,2))
        xllcorner        $(x)
        yllcorner        $(y)
        nodata_value     $(nodata_value)
        """
        for row in reverse(1:size(landscape, 1))
            for val in landscape[row,:]
                if isnan(val)
                    write(io, string(nodata_value)*" ")
                else
                    write(io, string(el)*" ")
                end
            end
            write(io, "\n")
        end
    end
end