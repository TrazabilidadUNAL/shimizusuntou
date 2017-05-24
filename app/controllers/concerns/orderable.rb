module Concerns
  module Orderable
    # A list of the param names that can be used for ordering the model list
    def ordering_params(params)
      # For example it retrieves a list of experiences in descending order of price.
      # Within a specific price, older experiences are ordered first
      #
      # GET /api/v1/experiences?sort=-price,created_at
      # ordering_params(params) # => { price: :desc, created_at: :asc }
      # Experience.order(price: :desc, created_at: :asc)
      #
      ordering = {}
      if params[:sort]
        sort_order = { '+' => :asc, '-' => :desc }

        sorted_params = params[:sort].split(',')
        sorted_params.each do |attr|
          sort_sign = (attr =~ /\A[+-]/) ? attr.slice!(0) : '+'
          model = controller_name.titlecase.singularize.constantize
          if model.attribute_names.include?(attr)
            ordering[attr] = sort_order[sort_sign]
          end
        end
      end
      ordering
    end
  end
end