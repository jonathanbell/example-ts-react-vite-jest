import { useState, useEffect } from "react";
import PlayingCard from "./PlayingCard";

function DeckOfCards() {
  const [deckId, setDeckId] = useState<string>("");

  useEffect(() => {
    async function fetchDeckOfCards() {
      try {
        const response = await fetch(
          `https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1`
        );
        const data = await response.json();
        console.log("Response with async await", data);
        setDeckId(data.deck_id);
      } catch (error) {
        console.error(error);
      }
    }
    fetchDeckOfCards();
  }, []);

  return (
    <div>
      <p>{deckId}</p>
      {deckId && <PlayingCard deckId={deckId} />}
    </div>
  );
}

export default DeckOfCards;
