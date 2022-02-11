using Documenter
using TwPrototypes

push!(LOAD_PATH,"../src/")
makedocs(sitename="TwPrototypes.jl",
         doctest  = false, 
         pages = [
            "Home" => "index.md",
            "Pkg utilities" => "pkg_utils.md",
            "Dispatch" => "isofeltype.md",
         ],
         modules = [TwPrototypes],
         format = Documenter.HTML(prettyurls = false)
)
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/bgctw/TwPrototypes.jl.git",
    devbranch = "main"
)
