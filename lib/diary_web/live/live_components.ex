defmodule DiaryWeb.LiveComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def icon(%{name: :syringe} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="syringe"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 512 512"
      class={@class}
    >
      <path
        fill="currentColor"
        d="M504.1 71.03l-64-64c-9.375-9.375-24.56-9.375-33.94 0s-9.375 24.56 0 33.94L422.1 56L384 94.06l-55.03-55.03c-9.375-9.375-24.56-9.375-33.94 0c-8.467 8.467-8.873 21.47-2.047 30.86l149.1 149.1C446.3 222.1 451.1 224 456 224c6.141 0 12.28-2.344 16.97-7.031c9.375-9.375 9.375-24.56 0-33.94L417.9 128L456 89.94l15.03 15.03C475.7 109.7 481.9 112 488 112s12.28-2.344 16.97-7.031C514.3 95.59 514.3 80.41 504.1 71.03zM208.8 154.1l58.56 58.56c6.25 6.25 6.25 16.38 0 22.62C264.2 238.4 260.1 240 256 240S247.8 238.4 244.7 235.3L186.1 176.8L144.8 218.1l58.56 58.56c6.25 6.25 6.25 16.38 0 22.62C200.2 302.4 196.1 304 192 304S183.8 302.4 180.7 299.3L122.1 240.8L82.75 280.1C70.74 292.1 64 308.4 64 325.4v88.68l-56.97 56.97c-9.375 9.375-9.375 24.56 0 33.94C11.72 509.7 17.86 512 24 512s12.28-2.344 16.97-7.031L97.94 448h88.69c16.97 0 33.25-6.744 45.26-18.75l187.6-187.6l-149.1-149.1L208.8 154.1z"
      >
      </path>
    </svg>
    """
  end

  def icon(%{name: :plate_utensils} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="plate_utensils"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 640 512"
      class={@class}
    >
      <path
        fill="currentColor"
        transform="scale(1,-1) translate(0,-512)"
        d="M130 214L120 214L120-24Q120-34 112-40Q106-48 96-48Q86-48 79-40Q72-34 72-24L72 214L62 214Q34 220 15 241Q6 255 2 271Q-2 288 2 304L28 421Q29 426 33 429Q38 432 43 432Q48 431 51 427Q55 423 55 418L55 295L70 295L85 422Q85 426 88 429Q92 432 96 432Q100 432 104 429Q107 426 108 422L122 295L137 295L137 418Q137 423 141 427Q144 431 149 432Q154 432 159 429Q163 426 164 421L190 304Q194 288 190 271Q187 255 176 241Q158 220 130 214L130 214M624 430Q629 428 633 424Q636 421 638 416Q640 411 640 406L640-24Q640-34 632-40Q626-48 616-48Q606-48 599-40Q592-34 592-24L592 128L544 128Q531 128 521 137Q512 147 512 160L512 290Q512 336 537 374Q563 412 605 430Q605 430 605 430Q610 433 614 432Q620 432 624 430L624 430L624 430M221 311L207 375Q273 421 353 415Q433 408 492 353Q481 322 481 290L481 260Q464 295 433 319Q402 343 363 350Q324 356 287 344Q250 332 222 304Q222 305 222 307Q222 309 221 311L221 311M427 282Q463 245 464 192Q464 153 442 121Q421 89 384 74Q349 59 311 66Q273 74 246 101Q218 129 211 168Q203 205 218 241Q233 277 265 298Q297 320 336 320Q389 319 427 282L427 282M499 115Q515 98 538 96Q513 42 464 8Q414-26 355-31Q295-36 240-11Q186 15 152 64L152 187Q165 192 177 200Q177 199 177 198Q176 195 176 192Q176 134 213 90Q250 46 307 35Q364 25 414 53Q464 82 485 135Q489 124 499 115L499 115L499 115Z"
      >
      </path>
    </svg>
    """
  end

  def icon(%{name: :fork_knife} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="plate_utensils"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 576 512"
      class={@class}
    >
      <path
        fill="currentColor"
        transform="scale(1,-1) translate(0,-480)"
        d="M153 127L54 225Q14 265 3 321Q-7 376 15 429Q18 436 24 441Q30 446 38 447Q46 449 54 447Q61 444 67 439L266 240L153 127L153 127M500 4Q512-8 512-24Q512-41 500-52Q488-64 472-64Q456-64 444-52L311 81L367 137L500 4L500 4M569 354Q575 350 576 344Q577 338 573 333L499 215Q488 198 472 188Q455 177 435 175Q402 172 375 190L132-52Q120-64 104-64Q88-64 76-52Q64-40 63-24Q64-8 76 4L318 247Q300 274 303 307Q305 327 316 343Q327 360 343 370L461 445Q466 449 472 448Q478 447 482 442Q486 438 486 431Q485 425 480 421L379 319L392 306L508 399Q512 402 517 402Q522 402 526 398Q530 394 530 389Q530 384 527 380L435 263L447 251L549 353Q553 357 559 358Q565 358 569 354L569 354L569 354Z"
      >
      </path>
    </svg>
    """
  end

  def icon(%{name: :pot_food} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="plate_utensils"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 640 512"
      class={@class}
    >
      <path
        fill="currentColor"
        transform="scale(1,-1) translate(0,-480)"
        d="M432 336Q393 335 365 313L365 313Q336 291 325 256L539 256Q527 291 499 313Q471 335 432 336L432 336M220 331Q239 319 240 296L240 280Q242 258 264 256Q286 258 288 280L288 296Q288 320 276 340Q265 360 244 373Q225 385 224 408L224 424Q222 446 200 448Q178 446 176 424L176 408Q176 384 188 364Q199 343 220 331L220 331M592 192L576 192Q576 206 567 215Q558 224 544 224L256 224L256 225L96 225Q82 225 73 215Q64 206 64 192L48 192Q34 192 25 183Q16 174 16 160Q16 146 25 137Q34 128 48 128L72 128Q85 77 116 35Q147-6 192-32Q192-46 201-55Q210-64 224-64L415-64Q429-64 438-55Q447-46 447-32Q492-6 523 35Q554 77 567 128L592 128Q606 128 615 137Q624 146 624 160Q624 174 615 183Q606 192 592 192L592 192M108 331Q127 319 128 296L128 280Q130 258 152 256Q174 258 176 280L176 296Q176 320 164 340Q153 360 132 373Q113 385 112 408L112 424Q110 446 88 448Q66 446 64 424L64 408Q64 384 76 364Q87 343 108 331L108 331Z"
      >
      </path>
    </svg>
    """
  end

  def icon(%{name: :person} = assigns) do
    assigns = assign_new(assigns, :class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <svg
      aria-hidden="true"
      focusable="false"
      data-prefix="fas"
      data-icon="plate_utensils"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 320 512"
      class={@class}
    >
      <path
        fill="currentColor"
        d="M208 48C208 74.51 186.5 96 160 96C133.5 96 112 74.51 112 48C112 21.49 133.5 0 160 0C186.5 0 208 21.49 208 48zM152 352V480C152 497.7 137.7 512 120 512C102.3 512 88 497.7 88 480V256.9L59.43 304.5C50.33 319.6 30.67 324.5 15.52 315.4C.3696 306.3-4.531 286.7 4.573 271.5L62.85 174.6C80.2 145.7 111.4 128 145.1 128H174.9C208.6 128 239.8 145.7 257.2 174.6L315.4 271.5C324.5 286.7 319.6 306.3 304.5 315.4C289.3 324.5 269.7 319.6 260.6 304.5L232 256.9V480C232 497.7 217.7 512 200 512C182.3 512 168 497.7 168 480V352L152 352z"
      />
    </svg>
    """
  end

  def icon(assigns) do
    assigns =
      assigns
      |> assign_new(:outlined, fn -> false end)
      |> assign_new(:class, fn -> "w-4 h-4 inline-block" end)

    ~H"""
    <%= if @outlined do %>
      <%= apply(Heroicons.Outline, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% else %>
      <%= apply(Heroicons.Solid, @name, [assigns_to_attributes(assigns, [:outlined, :name])]) %>
    <% end %>
    """
  end

  def breadcrumbs(assigns) do
    ~H"""
    <div class="breadcrumbs text">
      <ul>
        <%= for breadcrumb <- Enum.drop(@breadcrumbs, -1) do %>
          <li>
            <%= live_redirect to: breadcrumbs_link_to(breadcrumb) do %>
              <.breadcrumbs_title page={breadcrumb} />
            <% end %>
          </li>
        <% end %>
        <li>
          <span>
            <.breadcrumbs_title page={List.last(@breadcrumbs)} />
          </span>
        </li>
      </ul>
    </div>
    """
  end

  defp breadcrumbs_link_to(:home), do: "/home"
  defp breadcrumbs_link_to(:insulin), do: "/insulin"
  defp breadcrumbs_link_to(:settings), do: "/settings"
  defp breadcrumbs_link_to(:glucose), do: "/glucose"

  defp breadcrumbs_title(%{page: :home} = assigns) do
    ~H"""
    <.icon name={:home} class="h-6 w-6" />
    """
  end

  defp breadcrumbs_title(%{page: page}) do
    title =
      case page do
        :insulin -> "Insulin"
        page -> page |> Atom.to_string() |> String.capitalize()
      end

    assigns = %{
      title: title
    }

    ~H"""
    <span><%= @title %></span>
    """
  end

  def card(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> "" end)
      |> assign_new(:title, fn -> [] end)
      |> assign_new(:actions, fn -> [] end)

    ~H"""
    <div class={"card bg-base-100 shadow-lg #{@class}"}>
      <div class="card-body">
        <%= for title <- @title do %>
          <h2 class={"card-title only:mb-0 #{title[:class]}"}><%= render_slot(title) %></h2>
        <% end %>
        <%= render_slot(@inner_block) %>
        <%= for actions <- @actions do %>
          <div class={"card-actions #{actions[:class]}"}><%= render_slot(actions) %></div>
        <% end %>
      </div>
    </div>
    """
  end

  def modal(assigns) do
    ~H"""
    <input type="checkbox" id={"modal_#{@id}"} class="modal-toggle" phx-hook="Modal" />
    <div class="modal" phx-window-keydown={DiaryWeb.Modal.JS.close(@id)} phx-key="escape">
      <div class="modal-box" phx-click-away={DiaryWeb.Modal.JS.close(@id)}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def modal_actions(assigns) do
    ~H"""
    <div class="modal-action">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def modal_title(assigns) do
    ~H"""
    <div class="modal-title mb-4 only:mb-0">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
