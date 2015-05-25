module HerokuEnv
  class Railtie < Rails::Railtie
    config.before_configuration { load }

    def load
      HerokuEnv.run
    end

    def self.load
      instance.load
    end
  end
end
