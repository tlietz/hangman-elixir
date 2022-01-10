defmodule B2Web.PageController do
  use B2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
