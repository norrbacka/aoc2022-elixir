defmodule Solutions.Year2018.Day04 do
  @moduledoc """
  Solutions for Year 2018 and Day 4
  """
  defmacro __using__(_opts) do
    quote do
      def solve(input, 18_04_01) do
        ReposeRecord.part_one(input)
      end

      def solve(input, 18_04_02) do
        ReposeRecord.part_two(input)
      end
    end
  end
end

defmodule SantaDateTime do
  @moduledoc """
  Santas own date time type
  """

  import Kernel, except: [>: 2, <: 2, >=: 2, <=: 2]
  defstruct [:year, :month, :day, :hour, :minute]

  def new(date, time) do
    [year, month, day] = String.split(date, "-")
    [hour, minute] = String.split(time, ":")

    %SantaDateTime{
      year: String.to_integer(year),
      month: String.to_integer(month),
      day: String.to_integer(day),
      hour: String.to_integer(hour),
      minute: String.to_integer(minute)
    }
  end

  def a >= b do
    a > b || a == b
  end

  def a <= b do
    a < b || a == b
  end

  def a > b do
    a.year > b.year &&
      a.month > b.month &&
      a.day > b.day &&
      a.hour > b.hour &&
      a.minute > b.minute
  end

  def a < b do
    a.year < b.year &&
      a.month < b.month &&
      a.day < b.day &&
      a.hour < b.hour &&
      a.minute < b.minute
  end

  def diff(a, b) do
    %SantaDateTime{
      year: abs(a.year - b.year),
      month: abs(a.month - b.month),
      day: abs(a.day - b.day),
      hour: abs(a.hour - b.hour),
      minute: abs(a.minute - b.minute)
    }
  end

  def total_minutes(%SantaDateTime{
        year: year,
        month: month,
        day: day,
        hour: hour,
        minute: minute
      }) do
    year * 365 * 24 * 60 +
      month * 31 * 24 * 60 +
      day * 24 * 60 +
      hour * 60 +
      minute
  end

  def minutes_between(%SantaDateTime{} = a, %SantaDateTime{} = b, minutes \\ []) do
    {:ok, dt} = NaiveDateTime.new(b.year, b.month, b.day, b.hour, b.minute, 0)
    dt = NaiveDateTime.add(dt, 60, :second)

    b = %SantaDateTime{
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute
    }

    case Map.equal?(a, b) do
      true ->
        minutes

      false ->
        minutes = minutes ++ [b.minute]
        minutes_between(a, b, minutes)
    end
  end
end

defmodule TimecardMessage do
  @moduledoc """
  An parsed message describing action of an guard
  """
  defstruct [:event, :guard_id]

  def parse(raw_msg, previous_guard_id) do
    cond do
      String.starts_with?(raw_msg, "Guard") ->
        [_, text] = String.split(raw_msg, "#")
        [new_guard_id, _] = String.split(text, " begins shift")
        %TimecardMessage{event: :new_shift, guard_id: new_guard_id}

      raw_msg == "falls asleep" ->
        %TimecardMessage{event: :sleeping, guard_id: previous_guard_id}

      raw_msg == "wakes up" ->
        %TimecardMessage{event: :awake, guard_id: previous_guard_id}
    end
  end
end

defmodule Timecard do
  @moduledoc """
  An record of a timecard for an action of an guard and its shift at a given SantaDateTime
  """
  defstruct [:dt, :msg, :elapsed_minutes, :latest_dt]

  # Example: [1518-11-01 00:00] Guard #10 begins shift
  def parse(input, previous_guard_id, latest_dt, _with_minutes_between \\ false) do
    [raw_time, raw_msg] = String.split(input, "] ")
    [date, time] = String.replace(raw_time, "[", "") |> String.split(" ")
    dt = SantaDateTime.new(date, time)
    msg = TimecardMessage.parse(raw_msg, previous_guard_id)

    elapsed_minutes =
      if latest_dt != nil do
        SantaDateTime.diff(dt, latest_dt)
        |> SantaDateTime.total_minutes()
      else
        0
      end

    %Timecard{
      dt: dt,
      msg: msg,
      elapsed_minutes: elapsed_minutes,
      latest_dt: latest_dt
    }
  end

  def minutes_between(a) do
    %{dt: dt, latest_dt: latest_dt} = a

    if dt != nil and latest_dt != nil do
      SantaDateTime.minutes_between(dt, latest_dt, [latest_dt.minute])
    else
      []
    end
  end
end

defmodule ReposeRecord do
  @moduledoc """
  Solutions for Year 2018 and Day 4
  """

  def part_one_with_test_data() do
    raw_test_data = """
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:30] falls asleep
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-03 00:24] falls asleep
      [1518-11-03 00:29] wakes up
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
    """

    part_one(raw_test_data)
  end

  def part_one(input) do
    IO.puts("Building timecards...")

    {timecards, _} =
      input
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(&String.trim/1)
      |> Enum.map_reduce(nil, fn x, acc ->
        guard_id =
          if acc != nil do
            acc.msg.guard_id
          else
            nil
          end

        latest_dt =
          if acc != nil do
            acc.dt
          else
            nil
          end

        parsed = Timecard.parse(x, guard_id, latest_dt)
        {parsed, parsed}
      end)

    IO.puts("Fetching guards...")

    guards =
      timecards
      |> Enum.map(fn tc -> tc.msg.guard_id end)
      |> Enum.filter(fn id -> id != nil end)
      |> Enum.uniq()

    IO.puts("Counting...")

    sleeping_minutes =
      for guard <- guards do
        timecards_for_guard =
          Enum.filter(timecards, fn tc ->
            tc.msg.guard_id == guard && tc.msg.event == :awake
          end)

        minutes_asleep =
          timecards_for_guard
          |> Enum.map(fn tc -> tc.elapsed_minutes end)
          |> Enum.sum()

        %{
          guard_id: guard,
          minutes_asleep: minutes_asleep
        }
      end

    most_sleeping_guard =
      sleeping_minutes
      |> Enum.sort_by(fn x -> x.minutes_asleep end, :desc)
      |> Enum.at(0)

    most_sleeping_guard_id = most_sleeping_guard.guard_id

    timecards_for_guard =
      Enum.filter(timecards, fn tc ->
        tc != nil &&
          tc.msg != nil &&
          tc.msg.guard_id == most_sleeping_guard_id
      end)

    {most_sleeping_minute, _times} =
      timecards_for_guard
      |> Enum.flat_map(fn tc -> Timecard.minutes_between(tc) end)
      |> Enum.frequencies()
      |> Map.to_list()
      |> Enum.sort_by(fn {_minute, index} -> index end, :desc)
      |> Enum.at(0)

    most_sleeping_minute
  end

  def part_two(_input) do
    IO.puts("Unsolved")
  end
end
