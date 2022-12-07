defmodule AdventOfCode.TreeNode do
  defstruct parent: nil, children: %{}, name: "", value: 0

  alias AdventOfCode.TreeNode

  def add_child(pid, name, value) do
    # oh boy do i love agents!
    Agent.get_and_update(pid, fn treenode ->
      if Map.has_key?(treenode.children, name) do
        {Map.get(treenode.children, name), treenode}
      else
        new_inode = new(%TreeNode{parent: pid, name: name, value: value})

        {
          new_inode,
          %TreeNode{
            parent: treenode.parent,
            name: treenode.name,
            value: treenode.value,
            children: Map.put(treenode.children, name, new_inode)
          }
        }
      end
    end)
  end

  def update(treenode, value) do
    Agent.get_and_update(treenode, fn treenode ->
      t = %TreeNode{
        parent: treenode.parent,
        name: treenode.name,
        value: treenode.value + value,
        children: treenode.children
      }

      {t.value, t}
    end)
  end

  @spec parent(pid) :: pid
  def parent(treenode), do: Agent.get(treenode, & &1.parent)

  @spec empty?(pid) :: bool
  def empty?(treenode), do: Agent.get(treenode, &(map_size(&1.children) == 0))

  @spec value(pid) :: integer()
  def value(treenode) do
    subdirs =
      TreeNode.children(treenode)
      |> Enum.reduce([], fn {_, v}, acc ->
        [value(v) | acc]
      end)

    Agent.get(treenode, & &1.value) + Enum.sum(subdirs)
  end

  def children(treenode), do: Agent.get(treenode, & &1.children)

  def name(treenode), do: Agent.get(treenode, &(&1.name))

  def new(treenode \\ %TreeNode{}) do
    {:ok, pid} = Agent.start_link(fn -> treenode end)
    pid
  end
end
