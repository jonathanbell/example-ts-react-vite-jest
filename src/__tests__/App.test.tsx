import { render, screen } from "@testing-library/react";
import user from "@testing-library/user-event";

import App from "../App";

describe("App", () => {
  it("increments the counter on button click", async () => {
    render(<App />);
    const buttonCount = await screen.findByRole("button");

    expect(buttonCount.innerHTML).toBe("count is 0");

    await user.click(buttonCount);
    await user.click(buttonCount);

    expect(buttonCount.innerHTML).toBe("count is 2");
  });

  it("shows the alternative counter when the count is greater than 0", async () => {
    render(<App />);
    const buttonCount = await screen.findByRole("button");
    const conditionalCount = await screen.queryByText(/Count is now:/);

    expect(conditionalCount).not.toBeInTheDocument();

    await user.click(buttonCount);
    expect(await screen.queryByText(/Count is now:/)).toBeInTheDocument();
  });
});
