defmodule Messengyr.Repo.Migrations.CreateMessengyr.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end

    # Ensure unique index is maintained
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])

  end
end
