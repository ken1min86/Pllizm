class ImageExtensionValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.image.nil? && record.image.blank?
      unless Settings.constants.valid_extensions.any? { |valid_extension| record.image.include? valid_extension }
        record.errors.add(attribute, options[:message] || "の拡張子が不正です")
      end
    end
  end
end
