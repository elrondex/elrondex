defmodule Elrondex.Struct do
  require Decimal
  # TODO map to empty map
  def struct_load(struct, %{}, [], _version) do
    struct
  end

  def struct_load(struct, payload, [], _version) do
    # We have more keys in payload
    # TODO log this
    IO.puts("We have more keys in payload")
    struct
  end

  def struct_load(
        struct,
        payload,
        [
          {struct_field, payload_field, type, require, since_version, default}
          | tail_struct_fields
        ],
        version
      ) do
    case type do
      :integer ->
        struct_set_integer(
          struct,
          struct_field,
          Map.get(payload, payload_field),
          require,
          since_version >= version,
          default
        )

      :boolean ->
        struct_set_boolean(
          struct,
          struct_field,
          Map.get(payload, payload_field),
          require,
          since_version >= version,
          default
        )

      :decimal ->
        struct_set_decimal(
          struct,
          struct_field,
          Map.get(payload, payload_field),
          require,
          since_version >= version,
          default
        )

      :string ->
        struct_set_string(
          struct,
          struct_field,
          Map.get(payload, payload_field),
          require,
          since_version >= version,
          default
        )

      :list ->
        struct_set_list(
          struct,
          struct_field,
          Map.get(payload, payload_field),
          require,
          since_version >= version,
          default,
          version
        )
    end
    |> struct_load(Map.delete(payload, payload_field), tail_struct_fields, version)
  end

  def struct_load(struct, %{}, [
        {struct_field, payload_field, type, require, since_version, default} | tail
      ]) do
    struct
  end

  def struct_load(struct, payload, struct_fields) do
  end

  @require_yes true
  @require_no false
  @since_match_yes true
  @since_match_no false

  # struct, key, value, require, version_match, default
  def struct_set_integer(struct, key, value, _require, _since_match, _default)
      when is_integer(value) do
    Map.put(struct, key, value)
  end

  def struct_set_integer(struct, key, value, require, since_match, default)
      when is_binary(value) do
    case Integer.parse(value) do
      {int_value, ""} when is_integer(int_value) ->
        struct_set_integer(struct, key, int_value, require, since_match, default)

      _ ->
        raise "invalid integer value #{value} when load #{struct.__struct__} struct for key #{key}"
    end
  end

  def struct_set_integer(struct, key, nil, @require_no, _since_match, default)
      when is_integer(default) or default == nil do
    Map.put(struct, key, default)
  end

  def struct_set_integer(struct, key, nil, @require_yes, @since_match_no, _default) do
    struct
  end

  def struct_set_integer(struct, key, nil, @require_yes, @since_match_yes, _default) do
    raise "missign value for key #{key} when load #{struct.__struct__} struct"
  end

  # struct, key, value, require, version_match, default
  def struct_set_boolean(struct, key, value, _require, _since_match, _default)
      when is_boolean(value) do
    Map.put(struct, key, value)
  end

  def struct_set_boolean(struct, key, value, require, since_match, default)
      when is_binary(value) do
    case String.downcase(value) do
      "true" ->
        struct_set_boolean(struct, key, true, require, since_match, default)

      "false" ->
        struct_set_boolean(struct, key, false, require, since_match, default)

      _ ->
        raise "invalid boolean value #{value} when load #{struct.__struct__} struct for key #{key}"
    end
  end

  def struct_set_boolean(struct, key, nil, @require_no, _since_match, default)
      when is_boolean(default) or default == nil do
    Map.put(struct, key, default)
  end

  def struct_set_boolean(struct, key, nil, @require_yes, @since_match_no, _default) do
    struct
  end

  def struct_set_boolean(struct, key, nil, @require_yes, @since_match_yes, _default) do
    raise "missing value for key #{key} when load #{struct.__struct__} struct"
  end

  # struct, key, value, require, version_match, default
  def struct_set_decimal(struct, key, value, _require, _since_match, _default)
      when Decimal.is_decimal(value) do
    Map.put(struct, key, value)
  end

  def struct_set_decimal(struct, key, value, require, since_match, default)
      when is_binary(value) do
    case Decimal.parse(value) do
      {decimal_value, ""} when Decimal.is_decimal(decimal_value) ->
        struct_set_decimal(struct, key, decimal_value, require, since_match, default)

      _ ->
        raise "invalid decimal value #{value} when load #{struct.__struct__} struct for key #{key}"
    end
  end

  def struct_set_decimal(struct, key, nil, @require_no, _since_match, default)
      when Decimal.is_decimal(default) or default == nil do
    Map.put(struct, key, default)
  end

  def struct_set_decimal(struct, key, nil, @require_yes, @since_match_no, _default) do
    struct
  end

  def struct_set_decimal(struct, key, nil, @require_yes, @since_match_yes, _default) do
    raise "missign value for key #{key} when load #{struct.__struct__} struct"
  end

  # struct, key, value, require, version_match, default
  def struct_set_string(struct, key, value, _require, _since_match, _default)
      when is_binary(value) do
    Map.put(struct, key, value)
  end

  def struct_set_string(struct, key, nil, @require_no, _since_match, default)
      when is_binary(default) or default == nil do
    Map.put(struct, key, default)
  end

  def struct_set_string(struct, key, nil, @require_yes, @since_match_no, _default) do
    struct
  end

  def struct_set_string(struct, key, nil, @require_yes, @since_match_yes, _default) do
    raise "missign value for key #{key} when load #{struct.__struct__} struct"
  end

  # struct, key, value, require, version_match, default
  def struct_set_list(struct, key, value, _require, _since_match, default, version)
      when is_list(value) and is_function(default, 2) do
    Map.put(struct, key, Enum.map(value, fn elem -> default.(elem, 2) end))
  end

  def struct_set_list(struct, key, value, _require, _since_match, _default, _version)
      when is_list(value) do
    Map.put(struct, key, value)
  end

  def struct_set_list(struct, key, nil, _require, _since_match, _default, _version) do
    Map.put(struct, key, nil)
  end
end
