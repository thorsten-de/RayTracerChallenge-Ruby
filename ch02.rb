require_relative './raytracer.rb'

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
            velocity: Tuple.vector(1, 2, 0).normalize() * 12.0
        }

    E = 
        {
            gravity: Tuple.vector(0, -0.2, 0), 
            wind: Tuple.vector(-0.1, 0, 0)
        }
    
    PROJECTILE_COLOR = Tuple.color(1.0, 0.0, 0.0)

    def self.draw_projectile(canvas, projectile) 
        p = projectile[:position]
        canvas[p.x.round(), canvas.height -  p.y.round()] = PROJECTILE_COLOR
    end

    def self.simulate
        p = Projectile::P
        e = Projectile::E
        c = Canvas.new(900, 550)

        while (p[:position].y >= 0)
            draw_projectile(c, p)
            p = tick(e, p)
        end

        c.save_ppm('projectile.ppm')
    end
end

Projectile.simulate