defmodule DiscussWeb.TopicJSON do
  alias Discuss.Posts.Topic

  @doc """
  Renders a list of topics.
  """
  def index(%{topics: topics}) do
    %{data: for(topic <- topics, do: data(topic))}
  end

  @doc """
  Renders a single topic.
  """
  def show(%{topic: topic}) do
    %{data: data(topic)}
  end

  defp data(%Topic{} = topic) do
    %{
      id: topic.id,
      title: topic.title
    }
  end
end
