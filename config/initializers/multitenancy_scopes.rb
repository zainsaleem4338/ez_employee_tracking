# Not necessary. Good to have though
CLASSES_TO_EXCLUDE = [ActiveRecord::SchemaMigration]

MultiTenancyError = Class.new(StandardError)

# MONKEY PATCH -- Multitenancy
# Hooks into each ActiveRecords child class initialization process.
#   - Raises Exception in the event of a class missing a company_id  (dev env only)
#   - Appends default_scopes to the classes that require multitenancy
#
# IMP: Sphinx isn't catered into the framework atm
class ActiveRecord::Base
  if Rails.env.development? && ENV["INSTANCE_NAME"].present?
    establish_connection(ENV["INSTANCE_NAME"].to_sym)
  end
  def self.inherited(child)
    super

    child.instance_eval do
      def not_multitenant!
        @multitenant = false
      end

      def supports_multitenancy?
        @multitenant.nil? || @multitenant
      end
    end

    # Need an after inherit hook so that the classes initialize properly before we
    # begin monkey patching them.
    #
    # Ruby doesn't provide an after inherit hook, so lets make our own!
    # Read the docs son - http://ruby-doc.org/core-2.2.3/TracePoint.html#method-c-new
    trace = TracePoint.new(:end) do |tp|
      if tp.self == child # Trace point notifies events of other classes as well

        trace.disable

        # We dont really care about abstract classes as they are conceptual constructs
        # and do not map onto the DB
        if !child.abstract_class? && \
          CLASSES_TO_EXCLUDE.exclude?(child.name) && \
          child.supports_multitenancy? && \
          ENV['TENANT_OVERRIDE'] != 'true'

          # Crash the app if multitenancy is being violated!
          if %w[development test].include?(Rails.env) && \
            child.column_names.exclude?('company_id')

            raise MultiTenancyError, "#{child.name} does not have a Company ID"
          end

          child.instance_eval do
            default_scope { where(company_id: Company.current_id) }
          end
        end
      end
    end
    trace.enable
  end
end