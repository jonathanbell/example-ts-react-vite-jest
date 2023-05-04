#!/usr/bin/env bash

npm init vite --template react-ts my_app
cd my_app
npm i
npm i -D jest \
  @types/jest \
  ts-node \
  ts-jest \
  @testing-library/react \
  @testing-library/user-event \
  identity-obj-proxy \
  jest-environment-jsdom \
  @testing-library/jest-dom;

mkdir -p src/__tests__
touch src/__tests__/App.test.tsx
tee src/__tests__/App.test.tsx <<EOF > /dev/null
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
EOF

tee src/App.tsx <<EOF > /dev/null
import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";

function App() {
  const [count, setCount] = useState(0);

  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>

      {count > 0 ? <p>Count is now: {count}</p> : null}

      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
}

export default App;
EOF

touch jest.setup.ts
echo 'import "@testing-library/jest-dom/extend-expect";' >> jest.setup.ts

touch jest.config.js
tee src/App.tsx <<EOF > /dev/null
export default {
	testEnvironment: "jsdom",
	transform: {
		"^.+\\.tsx?$": "ts-jest"
	},
	moduleNameMapper: {
		'\\.(gif|ttf|eot|svg|png)$': '<rootDir>/test/__mocks__/fileMock.js',
		'\\.(css|less|sass|scss)$': 'identity-obj-proxy',
	},
	setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
}
EOF

sed -i '' 's/"dev": "vite",/"dev": "vite", "test": "jest",/' package.json

echo "Done! Run 'npm run test' to run tests."
echo
