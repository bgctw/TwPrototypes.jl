"""
Trait covering all types with eltype being inheriting from parameterized type.
"""
@traitdef IsOfEltype{X}
isofeltype(X) = eltype(X) <: Integer # TODO replace by parameterized type
@traitimpl IsOfEltype{X} <- isofeltype(X)
