if defined?(Spree::Tracker)
  Spree::Tracker.class_eval do
    belongs_to :store

    def self.current(engine = Spree::Tracker::TRACKING_ENGINES, domain)
      Spree::Tracker.where(engine: engine).active.joins(:store).where("spree_stores.url LIKE ?", "%#{domain}%").first
    end
  end
end

