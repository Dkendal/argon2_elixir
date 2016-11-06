defmodule Argon2 do
  @moduledoc """
  Elixir wrapper for the Argon2 password hashing algorithm.

  In most cases, you will just need to use the `hash_pwd_salt/2` and
  `verify_hash/3` functions from this module.
  """

  alias Argon2.Base

  @doc """
  Generate a random salt.
  """
  def gen_salt(salt_len \\ 16), do: :crypto.strong_rand_bytes(salt_len)

  @doc """
  Generate a random salt and hash a password using Argon2.
  """
  def hash_pwd_salt(password, opts \\ []) do
    Base.hash_password(password, Keyword.get(opts, :salt_len, 16) |> gen_salt, opts)
  end

  @doc """
  Verify an encoded Argon2 hash.
  """
  def verify_hash(stored_hash, password, opts \\ [])
  def verify_hash(stored_hash, password, opts) when is_binary(password) do
    hash = :binary.bin_to_list(stored_hash)
    case Base.verify_nif(hash, password, Keyword.get(opts, :argon2_type, 1)) do
      0 -> true
      _ -> false
    end
  end
  def verify_hash(_, _, _) do
    raise ArgumentError, "Wrong type - password should be a string"
  end
end
