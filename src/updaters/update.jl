"""
NeutralLandscapeUpdater is an abstract type for methods
for updating a landscape matrix
"""
abstract type NeutralLandscapeUpdater end 

"""
All `NeutralLandscapeUpdater`s have a field `rate`
which defines the expected (or mean) change across all cells per timestep.  
"""
rate(up::NeutralLandscapeUpdater) = up.rate

"""
All `NeutralLandscapeUpdater`'s have a `spatialupdater` field
which is either a `NeutralLandscapeMaker`, or `Missing` (in the case
of temporally correlated updaters).
"""
spatialupdater(up::NeutralLandscapeUpdater) = up.spatialupdater

"""
    variability(up::NeutralLandscapeUpdater)
    
    Returns the `variability` of a given `NeutralLandscapeUpdater`. 
    The variability of an updater is how much temporal variation there
    will be in a generated time-series of landscapes.
"""
variability(up::NeutralLandscapeUpdater) = up.variability

"""
normalize(mats::Vector{M})


Normalizes a vector of neutral landscapes `mats` such that all
values between 0 and 1. Note that this does not preserve the 
`rate` parameter for a given `NeutralLandscapeUpdater`, and instead
rescales it proportional to the difference between the total maximum
and total minimum across all `mats`.
"""
function normalize(mats::Vector{M}) where {M<:AbstractMatrix}
    mins, maxs = findmin.(mats), findmax.(mats)
    totalmin, totalmax = findmin([x[1] for x in mins])[1], findmax([x[1] for x in maxs])[1]
    returnmats = copy(mats)
    for (i,mat) in enumerate(mats)
        returnmats[i] = (mat .- totalmin) ./ (totalmax - totalmin)
    end
    return returnmats
end 


"""
update(updater::T, mat)

Returns one-timestep applied to `mat` based on the `NeutralLandscapeUpdater` 
provided (`updater`).
"""
function update(updater::T, mat) where {T<:NeutralLandscapeUpdater}
    _update(updater, mat)
end


"""
update(updater::T, mat, n::I)

Returns a sequence of length `n` where the original neutral landscape
`mat` is updated by the `NeutralLandscapeUpdater` `update` for `n` timesteps.
"""
function update(updater::T, mat, n::I) where {T<:NeutralLandscapeUpdater, I<:Integer}
    sequence = [zeros(size(mat)) for _ in 1:n]
    sequence[begin] .= mat
    for i in 2:n
        sequence[i] = _update(updater, sequence[i-1])
    end
    sequence
end


"""
update!(updater::T, mat)

Updates a landscape `mat` in-place by directly mutating `mat`.
"""
function update!(updater::T, mat) where {T<:NeutralLandscapeUpdater}
    mat .= _update(updater, mat)
end


