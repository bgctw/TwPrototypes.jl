# Makie Helpers

## Unit conversions
Many graphical properties are given in pixel or inches.
Working with figures for international journals, however, usually requires
thinking and specification in metric units. 
The following function help to convert.

```@docs
cm2inch
```

Figures often look well, if the ratio between length and hight corresponds
to the [Golden ratio](https://en.wikipedia.org/wiki/Golden_ratio). 
So we provide it here.

```@docs
golden_ratio
```

## Makie Layout switching

```@docs
MakieConfig
save_with_config
```

## Shortcuts
```@docs
hidexdecoration!
axis_contents
```

## Tailored plots
```@docs
density_params
```
