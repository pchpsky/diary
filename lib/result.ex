defmodule Result do
  @type ok_val :: term
  @type error_val :: term

  @type ok(a) :: {:ok, a}
  @type error(e) :: {:error, e}

  @type t(e, a) :: error(e) | ok(a)

  @moduledoc false

  @spec ok(ok_val) :: ok(term)
  def ok(v) do
    {:ok, v}
  end

  @spec error(term) :: error(term)
  def error(v) do
    {:error, v}
  end

  @spec cond(ok_val, (ok_val -> boolean), error_val) :: t(error_val, ok_val)
  def cond(v, pred, on_error) do
    if pred.(v), do: ok(v), else: error(on_error)
  end

  def from_optional(v) do
    cond(v, & &1, :none)
  end

  @spec map(t(error_val, ok_val), (ok_val -> term())) :: t(error_val, term())
  def map(result, cb) do
    and_then(result, fn value ->
      value
      |> cb.()
      |> ok()
    end)
  end

  @spec fold(t(error_val, ok_val), (error_val -> term()), (ok_val -> term())) :: term()
  def fold(result, left_cb, right_cb) do
    case result do
      {:ok, v} -> right_cb.(v)
      {:error, v} -> left_cb.(v)
    end
  end

  @spec and_then(t(error_val, ok_val), (ok_val -> t(term(), term()))) :: t(term(), term())
  def and_then(result, cb) do
    case result do
      {:ok, v} -> cb.(v)
      {:error, e} -> error(e)
    end
  end

  @spec tap(t(error_val, ok_val), (ok_val -> any)) :: t(error_val, ok_val)
  def tap(result, cb) do
    and_then(result, cb)
    result
  end

  def map_error(result, cb) do
    Result.Error.map(result, cb)
  end

  def tap_error(result, cb) do
    Result.Error.tap(result, cb)
  end

  def handle_error(result, cb) do
    Result.Error.and_then(result, cb)
  end
end

defmodule Result.Error do
  @spec new(term) :: Result.error_val()
  def new(value) do
    {:error, value}
  end

  @spec and_then(Result.t(Result.error_val(), Result.ok_val()), (Result.error_val() -> Result.t(term(), term()))) ::
          Result.t(term(), term())
  def and_then(result, cb) do
    case result do
      {:ok, v} -> Result.ok(v)
      {:error, e} -> cb.(e)
    end
  end

  @spec tap(Result.t(Result.error_val(), Result.ok_val()), (Result.error_val() -> any)) ::
          Result.t(Result.error_val(), Result.ok_val())
  def tap(result, cb) do
    and_then(result, cb)
    result
  end

  @spec map(Result.t(Result.error_val(), Result.ok_val()), (Result.ok_val() -> term())) ::
          Result.t(Result.error_val(), term())
  def map(result, cb) do
    and_then(result, fn value ->
      value
      |> cb.()
      |> new()
    end)
  end
end
