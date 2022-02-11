"""
    makeddocs()

Execute docs/make.jl in an environment that includes the current project.

By copying the docs/Project, activating it, adding the current project
and finally activating the environment used before.

This helps with the following issue:

- When running include("docs/make.jl") from the package environment, the package dependencies of the docs project are not checked.
- When running from docs environment, the dependency on the package under development is not included.
"""
function makeddocs() 
    path = mkpath("tmp/docs_project")
    cp("docs/Project.toml", joinpath(path,"Project.toml"), force=true)
    prev_path = Pkg.project().path
    try
        Pkg.activate(path)
        @show pwd()
        Pkg.develop(path=".")
        Base.include(Main, "docs/make.jl")
    finally
        Pkg.activate(prev_path)
    end
end
