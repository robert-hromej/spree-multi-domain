module Spree
  Store.class_eval do
    has_and_belongs_to_many :products, join_table: 'spree_products_stores'
    has_many :taxonomies
    has_many :orders

    has_many :store_payment_methods
    has_many :payment_methods, through: :store_payment_methods

    has_many :store_shipping_methods
    has_many :shipping_methods, through: :store_shipping_methods

    has_and_belongs_to_many :promotion_rules, class_name: 'Spree::Promotion::Rules::Store', join_table: 'spree_promotion_rules_stores', association_foreign_key: 'promotion_rule_id'

    # has_attached_file :logo,
    #   styles: { mini: '48x48>', small: '100x100>', medium: '250x250>' },
    #   default_style: :medium,
    #   url:  '/stores/:id/:style/:filename',
    #   path: ':rails_root/public/stores/:id/:style/:filename',
    #   convert_options: { all: '-strip -auto-orient' }
    #
    # validates_attachment_file_name :logo, matches: [/png\Z/i, /jpe?g\Z/i], if: -> { logo.present? }
    # validate :check_attachment_presence
    validate :check_attachment_content_type

    has_one_attached :logo

    def accepted_image_types
      %w(image/jpeg image/jpg image/png image/gif)
    end

    def check_attachment_presence
      return if logo.attached?

      logo.purge
      errors.add(:logo, :logo_must_be_present)
    end

    def check_attachment_content_type
      return unless logo.attached?
      return if logo.content_type.in?(accepted_image_types)

      document.purge
      errors.add(:logo, :not_allowed_content_type)
    end
  end
end
