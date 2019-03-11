defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start_link(fn -> 0 end)
    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account), do: process_account_action(account, &Agent.stop/1)

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account),
    do: process_account_action(account, fn account -> Agent.get(account, & &1) end)

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount),
    do: process_account_action(account, fn account -> Agent.update(account, &(&1 + amount)) end)

  defp process_account_action(account, action) do
    cond do
      Process.alive?(account) -> action.(account)
      true -> {:error, :account_closed}
    end
  end
end
