defmodule Elrondex.Shard do
  defmodule ShardStatus do
    defstruct erd_current_round: nil,
              erd_epoch_number: nil,
              erd_highest_final_nonce: nil,
              erd_nonce: nil,
              erd_nonce_at_epoch_start: nil,
              erd_nonces_passed_in_current_epoch: nil,
              erd_round_at_epoch_start: nil,
              erd_rounds_passed_in_current_epoch: nil,
              erd_rounds_per_epoch: nil

    # [struct_field, payload_field, type, require, since_version, default]
    def struct_fields() do
      [
        {:erd_current_round, "erd_current_round", :integer, true, 0, 0},
        {:erd_epoch_number, "erd_epoch_number", :integer, true, 0, 0},
        {:erd_highest_final_nonce, "erd_highest_final_nonce", :integer, true, 0, 0},
        {:erd_nonce, "erd_nonce", :integer, true, 0, 0},
        {:erd_nonce_at_epoch_start, "erd_nonce_at_epoch_start", :integer, true, 0, 0},
        {:erd_nonces_passed_in_current_epoch, "erd_nonces_passed_in_current_epoch", :integer,
         true, 0, 0},
        {:erd_round_at_epoch_start, "erd_round_at_epoch_start", :integer, true, 0, 0},
        {:erd_rounds_passed_in_current_epoch, "erd_rounds_passed_in_current_epoch", :integer,
         true, 0, 0},
        {:erd_rounds_per_epoch, "erd_rounds_per_epoch", :integer, true, 0, 0}
      ]
    end

    def from_status_payload(payload, version \\ 0) when is_map(payload) do
      struct_load(%ShardStatus{}, payload, struct_fields(), version)
    end

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
          |> struct_load(Map.delete(payload, payload_field), tail_struct_fields, version)
      end
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

    def struct_set_integer(struct, key, nil, @require_no, _since_match, default)
        when is_integer(default) do
      Map.put(struct, key, default)
    end

    def struct_set_integer(struct, key, nil, @require_yes, @since_match_no, _default) do
      struct
    end

    def struct_set_integer(struct, key, nil, @require_yes, @since_match_yes, _default) do
      raise "missign value for key #{key} when load ShardStatus struct"
    end
  end
end
