# adapted from https://github.com/cjdoris/julia-downgrade-compat-action/blob/main/downgrade.jl

"""
    downgrade_project()

Modifies Project.toml to use the lowest allowed version.
Caution: this looses the original Project.toml. Do this in a inspecting git branch
and later revert to the original branch.
"""
function downgrade_project(file = "Project.toml"; ignore_pkgs = ["Pkg","TOML","Statistics"], strict="v0")
    lines = readlines(file)
    compat = false
    for (i, line) in pairs(lines)
        if startswith(line, "[compat]")
            compat = true
        elseif startswith(line, "[")
            compat = false
        elseif startswith(strip(line), "#") || isempty(strip(line))
            continue
        elseif compat
            # parse the compat line
            m = match(r"^([A-Za-z0-9]+)( *= *\")([^\"]*)(\".*)", line)
            if m === nothing
                error("cannot parse compat line: $line")
            end
            pkg, eq, ver, post = m.captures
            # skip julia and any ignored packages
            if pkg == "julia" || pkg in ignore_pkgs
                println("skipping $pkg: $ver")
                continue
            end
            # just take the first part a list compat
            ver2 = strip(split(ver, ",")[1])
            if occursin(" - ", ver2)
                error("range specifiers not supported")
            end
            # separate the operator from the version
            if ver2[1] in "^~="
                op = ver2[1]
                ver2 = ver2[2:end]
            elseif isnumeric(ver2[1])
                op = '^'
            else
                println("skipping $pkg: $ver")
                continue
            end
            # parse the version
            ver2 = VersionNumber(ver2)
            # select a new operator
            if strict == "true"
                op = '='
            elseif strict == "v0" && ver2.major == 0
                op = '='
            elseif op == '^'
                op = '~'
            end
            # output the new compat entry
            ver2 = "$op$ver2"
            if ver == ver2
                println("skipping $pkg: $ver")
                continue
            end
            lines[i] = "$pkg$eq$ver2$post"
            println("downgrading $pkg: $ver -> $ver2")
        end
    end
    open(file, "w") do io
        for line in lines
            println(io, line)
        end
    end
end

