require_relative 'src/tuple'

module Projectile
    def self.tick(env, proj)
        { 
            position: proj[:position] + proj[:velocity],
            velocity: proj[:velocity] + env[:gravity] + env[:wind]
        }
    end

    P = 
        {
            position: Tuple.point(0, 1, 0), 
            velocity: Tuple.vector(1, 1, 0).normalize()
        }

    E = 
        {
            gravity: Tuple.vector(0, -0.1, 0), 
            wind: Tuple.vector(-0.01, 0, 0)
        }
end