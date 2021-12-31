abstract type TemporalUpdater end 

update(tu::T, x) where {T<:TemporalUpdater} = _getchange(tu, x) 

@kwdef struct BrownianMotion{S} <: TemporalUpdater
    σ::S = 0.1
end

_getchange(bm::BrownianMotion, x) = rand(Normal(bm.σ))


@kwdef struct OhrsteinUhlenbeck{S,T,F} <: TemporalUpdater
    θ::T = 1.
    σ::S  = 0.1
    dt::F = 0.01
end

_getchange(ou::OhrsteinUhlenbeck, x) = ou.dt*(-ou.θ*x  + rand(Normal(ou.σ)))

