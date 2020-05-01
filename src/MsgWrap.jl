module MsgWrap

export @msgwrap

using MacroTools: @q
import Logging

macro msgwrap(msg, expr)
    @q begin
        start = time()
        print($(esc(msg)), "... ");
        out = $(esc(expr));

        total_time = time() - start

        println("done! (" * FormatTime(total_time) * ")");
        out
    end
end

macro msgwrap(loglvl::Symbol, msg::AbstractString, expr)
    target_lvl = getfield(Logging, loglvl)
    @q begin
        cur_loglvl = Logging.current_logger().min_level
        if $target_lvl >= cur_loglvl
            print($(esc(msg)), "... ");
        end
        out = $(esc(expr));
        if $target_lvl >= cur_loglvl
            println("done!");
        end
        out
    end
end

function FormatTime(time)
    if time > 60*60
        string(round(time/60/60, digits=1)) * " hr"
    elseif time > 60
        string(round(time/60, digits=1)) * " min"
    else
        string(round(time, digits=3)) * " s"
    end
end



end # module
