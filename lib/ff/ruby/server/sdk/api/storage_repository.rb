require_relative "operators"
require_relative "../common/repository"

class StorageRepository < Repository

  def initialize(cache, store = nil, callback)

    @cache = cache
    @store = store
    @callback = callback
  end

  def get_flag(identifier, cacheable = true)

    flag_key = format_flag_key(identifier)
    flag = @cache.get(flag_key)

    if flag != nil

      return flag
    end

    if @store != nil

      flag = @store.get(flag_key)
      if flag != nil && cacheable

        @cache.set(flag_key, flag)
      end

      return flag
    end

    nil
  end

  def get_segment(identifier, cacheable)

    segment_key = format_segment_key(identifier)
    segment = @cache.get(segment_key)

    if segment != nil

      return segment
    end

    if @store != nil

      segment = @store.get(segment_key)
      if segment != nil && cacheable

        @cache.set(segment_key, segment)
      end

      return segment
    end

    nil
  end

  def find_flags_by_segment(identifier)

    result = []
    keys = @cache.keys

    if @store != nil

      keys = @store.keys
    end

    keys.each  do |key|

      flag = get_flag(key)

      if flag != nil && !flag.rules.length > 0

        flag.rules.each  do |rule|

          rule.clauses.each  do |clause|

            if clause.op == Operators.SEGMENT_MATCH && clause.values.include(identifier)

              result.push(flag.feature)
            end
          end
        end
      end
    end

    result
  end

  def set_flag(identifier, feature_config)

    # TODO: Override
  end

  def set_segment(identifier, segment)

    # TODO: Override
  end

  def delete_flag(identifier)

    # TODO: Override
  end

  def delete_segment(identifier)

    # TODO: Override
  end

  def close

    if @store != nil

      @store.close
    end
  end

  protected

  def format_flag_key(identifier)

    "flags/" + identifier
  end

  def format_segment_key(identifier)

    "segments/" + identifier
  end
end