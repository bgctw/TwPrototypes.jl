"similar to passmissing, creates a function that retuns nothing, if any of its arguments is noting."
passnothing(f) = (xs...; kwargs...) -> any(isnothing, xs) ? nothing : f(xs...;kwargs...)

# function _getindex_keep(ax::CA.AbstractAxis, syms::NTuple{N,Symbol}) where N
#     ntuple(i -> _getindex_keep(ax,syms[i]))
#     ci = ax[sym]
#     idx = ci.idx
#     if idx isa Integer
#         idx = idx:idx
#     end
#     if ci.ax isa CA.NullAxis || ci.ax isa CA.FlatAxis
#         new_ax = CA.Axis(NamedTuple{(sym,)}((ci.idx,)))
#     else
#         new_ax = CA.Axis(NamedTuple{(sym,)}((ViewAxis(idx, ci.ax),)))
#     end
#     new_ax = reindex(new_ax, -first(idx)+1)
#     return ComponentIndex(idx, new_ax)
# end
