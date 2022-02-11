"""
Concepts in Julia that have not found its proper package.
"""
module TwPrototypes

export 
    IsOfEltype

export 
    makeddocs    

using SimpleTraits    
import Pkg

include("isofeltype.jl")
include("pkg_utils.jl")

    
end # module
