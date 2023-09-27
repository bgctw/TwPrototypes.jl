"""
    makeddocs()

include docs/make.jl in the docs environment which devs the current project.

By copying the docs/Project, activating it, adding the current project
and finally activating the environment used before.
"""
function makeddocs() 
    path = "docs"
    prev_path = Pkg.project().path
    try
        Pkg.activate(path)
        @show pwd()
        Pkg.develop(path=".")
        #Pkg.instantiate()
        Base.include(Main, "docs/make.jl")
    finally
        Pkg.activate(prev_path)
    end
end
