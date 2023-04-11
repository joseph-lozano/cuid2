defmodule Cuid2 do
  @default_length 24
  @big_length 32
  @alphabet Enum.map(97..122, &<<&1::utf8>>)
  @initial_count_max 476_782_367

  def create_entropy(length \\ 4, random \\ &:rand.uniform/0, entropy \\ "") do
    if entropy > length do
      entropy
    else
      entropy <> ((random.() * 36) |> trunc |> Integer.to_string(36))
    end
  end

  def buf_to_big_int(buf) do
    buf
    |> :binary.bin_to_list()
    |> Enum.reduce(0, &(Bitwise.bsl(&2, 8) + &1))
  end

  def sha3_512(input) do
    :sha3_512
    |> :crypto.hash(input)
    |> buf_to_big_int()
  end

  def hash(input \\ "") do
    input
    |> sha3_512()
    |> Integer.to_string(36)
    |> String.downcase()
    |> String.slice(1..-1)
  end

  def create_fingerprint(random \\ :rand.uniform() / 0) do
    create_entropy(@big_length, random)
    |> hash()
    |> String.slice(0, @big_length)
  end

  def create_counter(count) do
    fn -> count + 1 end
  end

  def init(opts \\ []) do
    random = Keyword.get(opts, :random, &:rand.uniform/0)

    counter =
      Keyword.get_lazy(opts, :counter, fn ->
        create_counter(trunc(random.() * @initial_count_max))
      end)

    length = Keyword.get(opts, :length, @default_length)
    fingerprint = Keyword.get_lazy(opts, :fingerprint, fn -> create_fingerprint(random) end)

    fn ->
      first_letter = Enum.random(@alphabet)
      time = DateTime.utc_now() |> DateTime.to_unix() |> Integer.to_string(36)
      count = counter.() |> Integer.to_string(36)
      salt = create_entropy(length, random)
      hash_input = time <> salt <> count <> fingerprint
      (first_letter <> hash(hash_input)) |> String.slice(1, length)
    end
  end

  def create(opts \\ []) do
    init(opts).()
  end

  def is_cuid?(id, opts \\ [])

  def is_cuid?(id, opts) when is_binary(id) do
    min_length = Keyword.get(opts, :min_length, 2)
    max_length = Keyword.get(opts, :max_length, @big_length)
    length = String.length(id)
    regex = ~r/^[0-9a-z]+$/

    min_length <= length and length <= max_length and Regex.match?(regex, id)
  end

  def is_cuid?(_, _), do: false
end
